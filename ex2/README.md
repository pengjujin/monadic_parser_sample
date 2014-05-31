Monadic Parser �̗�
===================

Happy �� Alex ��p���� Monadic Perser �̗�Ƃ��āA�ȉ��̂悤�ȏ����Ȍ������������p�[�T������Ă݂܂����B
Parser/Lexer ����Ԃ������Ă��āA�\����͂̌��ʂɉ����ď�Ԃ��ς��܂��BHaskell �ŏ�Ԃ������ɂ́A���i�h�Ƃ����킯�ł��B

## ���������

Example 1 �ł́A���u���Z�q�����炩���ߒ�`����Ă���O��ŁA�l�����Z���܂ގ��̍\����͊�����܂����B

���x�́A�l�����Z�̂��߂̊֐� plus, minus, times, div �����炩���ߒ�`����Ă��āA
���u���Z�q�͂��Ƃ����`����悤�Ȍ�����l���܂��B

���u���Z�q�́A���̂悤�ɒ�`�ł�����̂Ƃ��܂��B�D��x�� 0, 1 �̂����ꂩ���w�肵�܂��B

    infixl 0 + plus;
    infixl 0 - minus;
    infixl 1 * times;
    infixl 1 / div;

���̌���ł́A�ŏ��̏�Ԃł͒��u���Z�q�͒�`����Ă��܂���B

    $ echo "1 + 2" | ./Parser
    parseError: Name: "+" at line 1, col 3

plus, minus �Ȃǂ͒�`����Ă��܂��B

    $ echo "plus 1 2" | ./Parser
    3

infixl ��p���Ē�`������ł���΁A���u���Z�q���g���܂��B

    $ echo "infixl 0 + plus; infixl 1 * times; 2 + 3 * 5" | ./Parser
    17

��̗�ł́A��Z�̗D��x�����������̂ŏ�Z����ɏ�������Ă��܂����A�����D��x�ɐݒ肵�Ă��΁A���̂悤�ɂȂ�܂��B

    $ echo "infixl 0 + plus; infixl 0 * times; 2 + 3 * 5" | ./Parser
    25

import React from 'react';
import { css, cx } from '@emotion/css';
import { COLORS } from '../common/theme';
import { ContentTemplate, ContentFooter } from '../components';
import { useForm, SubmitHandler } from 'react-hook-form';

const styles = {
    container: css`
        display: flex;
        justify-content: center;
        align-items: center;
    `,
    content: css`
        width: 600px;
        margin: 30px 16px 60px;
    `,
    item: css`
        &:not(:first-child) {
            margin-top: 16px;
        }
    `,
    validationError: css`
        font-size: 1.5rem;
        color: red;
        margin: 0;
    `,
    text: css`
        display: block;
        line-height: 45px;
        padding: 0 12px;
        background-color: #eff1f5;
        width: 100%;
        border-radius: 3px;
        border: none;
    `,
    multitext: css`
        display: block;
        line-height: 24px;
        background-color: #eff1f5;
        padding: 8px 12px;
        width: 100%;
        border-radius: 3px;
        border: none;
    `,
    submit: css`
        margin-top: 24px;
        letter-spacing: 0.4em;
        color: #fff;
        background-color: ${COLORS.MAIN};
        cursor: pointer;
        border-radius: 0.5rem;
        border: none;

        height: 48px;
        font-weight: bold;
        font-size: 1.7rem;
        width: 100%;
    `,
    contentFooter: css`
        margin: 0 auto 40px;
    `,
    submitResultContainer: css`
        margin-top: 8px;
    `,
    submitResult: css`
        font-weight: bold;
    `,
}

type InputType = {
    name: string;
    mail: string;
    title: string;
    message: string;
}

type ResultType = 'success' | 'failure' | 'none';

const submitResultMessages = {
    success: 'お問い合わせありがとうございます。メッセージは送信されました。',
    failure: '送信に失敗しました。再度お試しください。'
}

const Contact = () => {
    const [submitResult, setSubmitResult] = React.useState<ResultType>('none');
    const { register, handleSubmit, reset, watch, formState: { errors } } = useForm<InputType>({
        mode: 'onChange',
        defaultValues: {
            name: '',
            mail: '',
            title: '',
            message: ''
        },
    });

    // console.log(watch('name'));


    const sendMail = async (data: InputType) => {
        return await fetch('https://asia-northeast1-imadoko-12cdf.cloudfunctions.net/sendMail', {
            method: 'post',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              data: {
                name: data.name,
                email: data.mail,
                title: data.title,
                message: data.message
            }})
        });
    };

    const onSubmit: SubmitHandler<InputType> = data => {
        sendMail(data).then(response => {
            reset();
            setSubmitResult('success');
        }).catch(reason => {
            setSubmitResult('failure');
        });
    };

    const submitResultContainerStyle = css`
        ${styles.submitResultContainer}
        display: ${submitResult === 'none' ? 'none' : 'block'};
    `;

    const submitResultStyle = css`
        ${styles.submitResult}
        color: ${submitResult === 'success' ? 'green' : 'red'};
    `;

    const submitResultMessage = submitResult === 'success' ? submitResultMessages.success : submitResultMessages.failure;

    const submitStyle = css`
        ${styles.submit}
        background-color: ${submitResult === 'success' ? COLORS.DISALBED : COLORS.MAIN};
    `;

    return (
        <ContentTemplate>
            <div className={styles.container}>
                <div className={styles.content}>
                    <h2>お問い合わせ</h2>
                    <form action="post" onSubmit={handleSubmit(onSubmit)}>
                        <div className={styles.item}>
                            <label htmlFor="name">お名前（必須）</label>
                            <input className={styles.text} type="text" id="name" {...register('name', { required: '名前を入力してください'})} />
                            <p className={styles.validationError}>{errors.name?.message}</p>
                        </div>

                        <div className={styles.item}>
                            <label htmlFor="mail">メールアドレス（必須）</label>
                            <input className={styles.text} type="email" id="mail" {...register('mail', { required: 'メールアドレスを入力してください'})} />
                            <p className={styles.validationError}>{errors.mail?.message}</p>
                        </div>

                        <div className={styles.item}>
                            <label htmlFor="title">題名（必須）</label>
                            <input className={styles.text} type="text" id="title" {...register('title', { required: '題名を入力してください'})} />
                            <p className={styles.validationError}>{errors.title?.message}</p>
                        </div>

                        <div className={styles.item}>
                            <label htmlFor="message">メッセージ本文（必須）</label>
                            <textarea className={styles.multitext} id="message" cols={40} rows={10} {...register('message', { required: 'メッセージ本文を入力してください'})} />
                            <p className={styles.validationError}>{errors.message?.message}</p>
                        </div>

                        <input type="submit" disabled={submitResult === 'success' ? true : false} className={submitStyle} />

                        <div className={submitResultContainerStyle}>
                            <p className={submitResultStyle}>{submitResultMessage}</p>
                        </div>
                    </form>
                </div>
            </div>

            <ContentFooter className={styles.contentFooter} firstLink={'introduction'} secondLink={'policy'} />

        </ContentTemplate>
    )

};

export default Contact;